describe('Visits exams list page', () => {

  describe('Visits exams list page', () => {
    it('And successfully send data to server', () => {
      cy.visit('/exams');
  
      cy.get('input[type=file]').selectFile('./cypress/fixtures/csv/data2.csv')
  
      cy.intercept('POST', '/import', {
        statusCode: 202,
        body: 'Requisição enviada ao servidor, volte mais tarde ver as atualizações'
      }).as('fileUpload');

      cy.get('#send-button').click();
  
      cy.on('window:alert', (text) => {
        expect(text).to.contains('Requisição enviada ao servidor, volte mais tarde ver as atualizações');
      });
  
      cy.wait('@fileUpload');
    });
  });

  it('And send no file to server', () => {
    cy.visit('/exams');

    cy.get('#send-button').click();

    cy.on('window:alert', (text) => {
      expect(text).to.contains('Por favor, selecione um arquivo.');
    });
  });
});