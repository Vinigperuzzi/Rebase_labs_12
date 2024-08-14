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

  it('And sees the info ordered by name, separated by person, then for exam and the list os exams for each token', () => {
    cy.visit('/exams');

    cy.contains('Agatha Pedroso');
    cy.contains('CPF: 002.678.897-71');
    cy.contains('Data de nascimento: 06/01/1966 | E-mail: alberto@bernhard.com | 360 Marginal Leonardo - Urucará - Rondônia');
    cy.contains('Exame 4NFEXQ - 24/05/2021');
    cy.contains('Médico(a): Ana Sophia Aparício Neto | CRM: B000BJ8TIA - PR');
    cy.contains('E-mail: corene.hane@pagac.io');
    cy.contains('hemácias 45-52 4');
    cy.contains('leucócitos 9-61 9');
    cy.contains('plaquetas 11-93 59');
    cy.contains('hdl 19-75 3');
    cy.contains('ldl 45-54 36');
    cy.contains('Exame 894E9@ - 08/05/2021');
    cy.contains('Médico(a): Maria Luiza Pires | CRM: B000BJ20J4 - PI');
    cy.contains('E-mail: denna@wisozk.biz');

    cy.contains('Vinícius Garcia Peruzzi');
    cy.contains('CPF: 458.789.223-45');
    cy.contains('Data de nascimento: 17/10/1992 | E-mail: vinisinatra@ruby.com | 789 Flores da Cunha - Pelotas - Rio Grande Do Sul');
    cy.contains('Exame 212121 - 05/08/2021');
    cy.contains('Médico(a): Maria Luiza Pires | CRM: B000BJ20J4 - PI');
    cy.contains('E-mail: denna@wisozk.biz');
    cy.contains('hemácias 45-52 50')
    cy.contains('leucócitos 9-61 30')
    cy.contains('plaquetas 11-93 50')
    cy.contains('hdl 19-75 36')
    cy.contains('ldl 45-54 50')
    cy.contains('vldl 48-72 65')
    cy.contains('glicemia 25-83 65')
    cy.contains('tgo 50-84 52')
    cy.contains('tgp 38-63 55')
    cy.contains('eletrólitos 2-68 34')
    cy.contains('tsh 25-80 46')
    cy.contains('t4-livre 34-60 62')
    cy.contains('ácido úrico 15-61 13')
  });

  it('And cannot access the database', () => {
    cy.visit('/exams', {
      onLoad: (win) => {
        cy.stub(win, 'append_people').throws(new Error('Simulated Error'));
      }
    });

    cy.contains('Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.');
  });

  afterEach(() => {
    cy.request('POST', '/drop_test_db');
  });
});