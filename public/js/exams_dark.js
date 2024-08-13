let host = 'localhost';
let host_port = `http://${host}:3000`;
let all_cpf_url = `${host_port}/all_cpfs`;
let all_cpf_info = `${host_port}/all_cpf_info/`;
let all_cpf_tokens = `${host_port}/all_cpf_tokens/`;
let all_token_info = `${host_port}/all_token_info/`;
let all_types_info = `${host_port}/all_token_types/`;
let exam_details = `${host_port}/exams-dark/`;

function format_date(date){
  let [year, month, day] = date.split('-')
  return `${day}/${month}/${year}`;
}

async function append_table(token){
  let url = `${all_types_info}${token}`
  let response = await fetch(url);
  let types_info = await response.json();
  let table = `
    <thead>
      <tr>
        <th>Tipo de Exame</th>
        <th>Valores Limite</th>
        <th>Resultado</th>
      </tr>
    </thead>
    <tbody>
  `;
  for(let type of types_info) {
    table += `
        <tr>
          <td>${type.exam_type}</td>
          <td>${type.exam_type_limits}</td>
          <td>${type.exam_type_value}</td>
        </tr>
      
    `;
  }
  table += '</tbody>';
  return table
}

async function append_exams(cpf){
  let url = `${all_cpf_tokens}${cpf}`
  let response = await fetch(url);
  let tokens_list = await response.json();
  let cards = '';
  for(let token of tokens_list) {
    let token_url = `${all_token_info}${token}`;
    let token_response = await fetch(token_url);
    let info = await token_response.json();
    let card = `
      <div class="col-sm-6 mb-3 mb-sm-0 mt-4">
        <div class="card bg-secondary text-light">
          <div class="card-body">
            <h5 class="card-title text-light">Exame ${info.token} - ${format_date(info.exam_date)}</h5>
            <p class="card-text">
              Médico(a): ${info.dr_name} | CRM: ${info.dr_crm} - ${info.dr_state} <br>
              E-mail: ${info.dr_email}
            </p>
            <table class="table table-dark table-hover">
              ${await append_table(token)}
            </table>
            <a href="${exam_details}${token}" class="btn btn-outline-light">Detalhes</a>
          </div>
        </div>
      </div>
    `;
    cards += card;
  }
  return cards;
}

async function get_cpfs() {
  let response = await fetch(all_cpf_url);
  let cpfs_list = await response.json();
  return cpfs_list
}

async function append_people(cpfs_list){
  let cards = '';
  for (let cpf of cpfs_list) {
    let url = `${all_cpf_info}${cpf}`;
    let response = await fetch(url);
    let info = await response.json();
    let card = `
      <div class="card mt-5 bg-dark">
        <div class="card-body bg-dark text-light">
          <h5 class="card-title text-light">${info.full_name}</h5>
          <h6 class="card-subtitle mb-2 text-light">CPF: ${info.cpf}</h6>
          <p>Data de nascimento: ${format_date(info.birth_date)} | E-mail: ${info.email} | ${info.address} - ${info.city} - ${info.state}</p>
          <div class="row">
            ${await append_exams(cpf)}
          </div>
        </div>
      </div>
    `;
    cards += card;
  }
  document.querySelector('.exams-list').innerHTML = cards;
}

async function main() {
  try {
    cpfs_list = await get_cpfs();
    await append_people(cpfs_list);
  } catch (error) {
    try {
      host = 'app';
      host_port = `http://${host}:3000`;
      all_cpf_url = `${host_port}/all_cpfs`;
      all_cpf_info = `${host_port}/all_cpf_info/`;
      all_cpf_tokens = `${host_port}/all_cpf_tokens/`;
      all_token_info = `${host_port}/all_token_info/`;
      all_types_info = `${host_port}/all_token_types/`;
      exam_details = `${host_port}/exams/`;
      cpfs_list = await get_cpfs();
      await append_people(cpfs_list.slice(0,2));
    } catch (error) {
      let message = "<p style='color: #ba1234'>Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.</p>";
      document.querySelector('.exams-list').innerHTML = message;
    }
  }
}
main();