describe('Visits exams list', () => {
  it('And sees the info ordered by name, separated by person, then for exam and the list os exams for each token', () => {
    cy.visit('/exams');

    cy.contains('Agatha Pedroso');
    cy.contains('CPF: 002.678.897-71');
    cy.contains('Data de nascimento: 06/01/1966 | E-mail: alberto@bernhard.com | 360 Marginal Leonardo - Urucará - Rondônia');
    cy.contains('Exame 4NFEXP - 24/05/2021');
    cy.contains('Médico(a): Ana Sophia Aparício Neto | CRM: B000BJ8TIA - PR');
    cy.contains('E-mail: corene.hane@pagac.io');
    cy.contains('Exame 58PYO5 - 13/08/2021');
    cy.contains('Médico(a): Oliver Palmeira | CRM: B000AR99QO - MS');
    cy.contains('E-mail: lawana.erdman@waters.info');
    cy.contains('Ana Beatriz Rios');
    cy.contains('CPF: 018.581.237-63');
    cy.contains('Data de nascimento: 26/09/1989 | E-mail: hobert_marquardt@kulas.biz | 6425 Rua Emilly Nogueira - Carnaubal - Distrito Federal');
    cy.contains('Exame B2KHO4 - 01/12/2021');
    cy.contains('Médico(a): Dra. Isabelly Rêgo | CRM: B0002W2RBG - CE');
    cy.contains('E-mail: diann_klein@schinner.org');
  });

  it('And cannot access the database', () => {
    cy.visit('/exams', {
      onLoad: (win) => {
        cy.stub(win, 'append_people').throws(new Error('Simulated Error'));
      }
    });

    cy.contains('Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.');
  });
});