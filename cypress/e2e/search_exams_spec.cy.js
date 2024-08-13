describe('Visits exams list', () => {
  it('And search for an exam', () => {
    cy.visit('/exams');

    cy.get('#token').type('4NFEXP');
    cy.get('#search-button').click();

    cy.url().should('include', '/exams/4NFEXP');
  });
});