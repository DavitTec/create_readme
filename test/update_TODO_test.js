const { expect } = require('chai');
const { exec } = require('child_process');
const fs = require('fs').promises;
const path = require('path');

describe('update_TODO.sh', () => {
  const testDir = './docs/test';
  const testTodoFile = path.join(testDir, 'ToDo.md');
  const scriptPath = './update_TODO.sh';

  // Setup before all tests
  before(async () => {
    // Create test directory and files
    await fs.mkdir(testDir, { recursive: true });
    await fs.writeFile(testTodoFile, `
# Todo
## Tasks
- [ ] Test §SCRIPT_NAME(1) (§SCRIPT_STATE(1))
    `);
    await fs.mkdir('./scripts', { recursive: true });
    await fs.writeFile('./scripts/test_script.sh', `
#!/bin/bash
# Author: TestUser
# State: testing
VERSION="1.0.0"
echo "Test"
    `);
  });

  // Cleanup after all tests
  after(async () => {
    await fs.rm(testDir, { recursive: true, force: true });
    await fs.rm('./scripts/test_script.sh', { force: true });
  });

  it('should update ToDo.md with script info in test mode', (done) => {
    exec(`bash ${scriptPath}`, async (error, stdout, stderr) => {
      try {
        expect(error).to.be.null;
        expect(stdout).to.include('Running in TEST mode');
        expect(stdout).to.include('Updated ./docs/test/ToDo.md successfully');

        const updatedContent = await fs.readFile(testTodoFile, 'utf8');
        expect(updatedContent).to.include('Test test_script.sh (testing)');
        done();
      } catch (err) {
        done(err);
      }
    });
  });

  it('should delete test directory with -d flag', (done) => {
    exec(`bash ${scriptPath} -d`, async (error, stdout, stderr) => {
      try {
        expect(error).to.be.null;
        expect(stdout).to.include('Test directory ./docs/test deleted');

        await fs.access(testDir).then(() => {
          done(new Error('Test directory was not deleted'));
        }).catch(() => {
          done(); // Success if directory is gone
        });
      } catch (err) {
        done(err);
      }
    });
  });
});