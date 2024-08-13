module.exports = {
  e2e: {
    baseUrl: 'http://app:3000',
    supportFile: false,
    setupNodeEvents(on, config) {
      // Eventos de configuração adicionais
    },
    defaultCommandTimeout: 12000
  },
};