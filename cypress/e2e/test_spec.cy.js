describe('My First Test', () => {
  it('Visits the app', () => {
    cy.visit('/hello');
    cy.contains('Hello world!');
  });
});