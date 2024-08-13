require 'spec_helper'
require './server'

describe 'User visit exam list page', type: :feature do
  it 'and cannot access the database' do
    visit '/exams-dark'

    puts html
    expect(page).to have_content('Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.')
  end

  it 'and access /hello' do
    visit '/hello'

    expect(page).to have_content('Hello world!')
  end
end
