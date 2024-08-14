describe('Visits exams list', () => {

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

  it('And search for an exam', () => {
    cy.intercept('GET', '/exams/*').as('redirect');

    cy.visit('/exams');

    cy.get('#token').type('4NFEXQ');
    cy.get('#search-button').click();
    cy.wait('@redirect').then((interception) => {
      expect(interception.request.url).to.include('/exams/4NFEXQ');
    });
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

  it('And search for an invalid exam', () => {
    cy.intercept('GET', '/exams/*').as('redirect');

    cy.visit('/exams');

    cy.get('#token').type('000000');
    cy.get('#search-button').click();
    cy.wait('@redirect').then((interception) => {
      expect(interception.request.url).to.include('/exams/000000');
    });
    cy.contains('Não existe exame com Token 000000');
  });

  it('And let blank field', () => {
    cy.intercept('GET', '/exams/*').as('redirect');

    cy.visit('/exams');

    cy.get('#search-button').click();
    cy.wait('@redirect').then((interception) => {
      expect(interception.request.url).to.include('/exams/0');
    });
    cy.contains('Não existe exame com Token 0');
  });

  afterEach(() => {
    cy.request('POST', '/drop_test_db');
  });
});