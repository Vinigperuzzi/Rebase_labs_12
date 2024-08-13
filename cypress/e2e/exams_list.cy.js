const { exec } = require('child_process');

describe('Visits exams list', () => {
  it('And cannot access the database', () => {
    cy.visit('/exams');
    cy.contains('Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.');
  });

  
});