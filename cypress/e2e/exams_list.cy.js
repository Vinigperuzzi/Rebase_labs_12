const { exec } = require('child_process');

describe('Visits exams list', () => {
  it('And cannot access the database', () => {
    cy.visit('/exams');
    cy.contains('Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.');
  });

  it('And sees the info ordered by name, separated by person, then for exam and the list os exams for each token', () => {
    exec('docker-compose run --rm test_runner ruby lib/populate_db_test.rb', (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      console.log(`stdout: ${stdout}`);
      console.error(`stderr: ${stderr}`);
    });
    cy.visit('/exams');
    cy.contains('Agatha Pedroso');
  });
});