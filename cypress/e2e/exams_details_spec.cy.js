describe('Visits exams details', () => {

  beforeEach(() => {
    cy.request('POST', `/populate_test_db?file_data=./public/csv/data2.csv`);
    cy.intercept('*', (req) => {
      if (req.url.includes('?')) {
        req.url = `${req.url}&cypress_test=true`;
      } else {
        req.url = `${req.url}?cypress_test=true`;
      }
      req.continue();
    });
  });

  it('And shows detailed info about the exame specified by token', () => {
    cy.visit('/exams/4NFEXQ');

    cy.contains('Agatha Pedroso');
    cy.contains('CPF: 002.678.897-71');
    cy.contains('Data de nascimento: 06/01/1966 | E-mail: alberto@bernhard.com');
    cy.contains('Exame 4NFEXQ - 24/05/2021');
    cy.contains('Médico(a): Ana Sophia Aparício Neto | CRM: B000BJ8TIA - PR');
    cy.contains('hemácias 45-52 66 Acima');
    cy.contains('leucócitos 9-61 80 Acima');
    cy.contains('plaquetas 11-93 93 Bom');
    cy.contains('hdl 19-75 62 Bom');
    cy.contains('ldl 45-54 11 Abaixo');
    cy.contains('vldl 48-72 84 Acima');
    cy.contains('glicemia 25-83 27 Bom');
    cy.contains('tgo 50-84 77 Bom');
    cy.contains('tgp 38-63 70 Acima');
    cy.contains('eletrólitos 2-68 49 Bom');
    cy.contains('tsh 25-80 17 Abaixo');
    cy.contains('t4-livre 34-60 0 Abaixo');
    cy.contains('ácido úrico 15-61 35 Bom');
  });

  it('And cannot access the database', () => {
    cy.visit('/exams/4NFEXQ', {
      onLoad: (win) => {
        cy.stub(win, 'append_person').throws(new Error('Simulated Error'));
      }
    });

    cy.contains('Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.');
  });

  afterEach(() => {
    cy.request('POST', '/drop_test_db');
  });
});