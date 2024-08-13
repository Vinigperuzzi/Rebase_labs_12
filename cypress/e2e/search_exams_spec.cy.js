describe('Visits exams list', () => {
  it('And search for an exam', () => {
    cy.intercept('GET', '/exams/*').as('redirect');

    cy.visit('/exams');

    cy.get('#token').type('4NFEXP');
    cy.get('#search-button').click();
    cy.wait('@redirect').then((interception) => {
      expect(interception.request.url).to.include('/exams/4NFEXP');
    });
  });
});