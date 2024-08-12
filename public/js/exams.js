const host_port = 'http://localhost:3000'
const all_cpf_url = `${host_port}/all_cpfs`;
const all_cpf_info = `${host_port}/all_cpf_info/`;
const all_cpf_tokens = `${host_port}/all_cpf_tokens/`;
const all_token_info = `${host_port}/all_token_info/`;
const all_types_info = `${host_port}/all_token_types/`;

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
        <div class="card bg-white text-dark">
          <div class="card-body">
            <h5 class="card-title text-dark">Exame ${info.token} - ${format_date(info.exam_date)}</h5>
            <p class="card-text">
              Médico(a): ${info.dr_name} | CRM: ${info.dr_crm} - ${info.dr_state} <br>
              E-mail: ${info.dr_email}
            </p>
            <table class="table table-hover">
              ${await append_table(token)}
            </table>
            <button href="#" type="button" class="btn btn-outline-dark">Detalhes</button>
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
      <div class="card mt-5 bg-light">
        <div class="card-body bg-light text-dark">
          <h5 class="card-title text-dark">${info.full_name}</h5>
          <h6 class="card-subtitle mb-2 text-muted">CPF: ${info.cpf}</h6>
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
  cpfs_list = await get_cpfs();
  append_people(cpfs_list);
}

main();