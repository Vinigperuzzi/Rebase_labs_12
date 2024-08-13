let host_port = 'http://localhost:3000'
let exam_details = `${host_port}/tests/`;

function format_date(date){
  let [year, month, day] = date.split('-')
  return `${day}/${month}/${year}`;
}

async function append_table(info){
  let table = `
    <thead>
      <tr>
        <th>Tipo de Exame</th>
        <th>Valores Limite</th>
        <th>Resultado</th>
        <th>Indicador</th>
      </tr>
    </thead>
    <tbody>
  `;
  for(let test of info.tests) {
    table += `
        <tr>
          <td>${test.type}</td>
          <td>${test.limits}</td>
          <td>${test.result}</td>
    `;
    let [min, max] = test.limits.split('-');
    if (Number(test.result) < Number(min)){
      table += `
        <td style='color: red'>Abaixo</td>
        </tr>
      `;
    } else if (Number(test.result) > Number(max)) {
      table += `
        <td style='color: red'>Acima</td>
        </tr>
      `;
    } else {
      table += `
        <td style='color: green'>Bom</td>
        </tr>
      `;
    }
  }
  table += '</tbody>';
  return table
}

async function append_exam(info){
  let card = `
    <div class="mb-3 mb-sm-0 mt-4">
      <div class="card bg-white text-dark">
        <div class="card-body">
          <h5 class="card-title text-dark">Exame ${info.result_token} - ${format_date(info.result_date)}</h5>
          <p class="card-text">
            Médico(a): ${info.doctor.name} | CRM: ${info.doctor.crm} - ${info.doctor.crm_state} <br>
          </p>
          <table class="table table-hover">
            ${await append_table(info)}
          </table>
        </div>
      </div>
    </div>
  `;
  return card;
}

async function append_person(token){
  let url = `${exam_details}${token}`;
  let response = await fetch(url);
  let info = await response.json();
  if(!info){
    document.querySelector('.exams-list').innerHTML = `<p>Não existe exame com Token ${token}</p>`;
    return;
  }
  let card = `
    <div class="card mt-5 bg-light">
      <div class="card-body bg-light text-dark">
        <h5 class="card-title text-dark">${info.name}</h5>
        <h6 class="card-subtitle mb-2 text-muted">CPF: ${info.cpf}</h6>
        <p>Data de nascimento: ${format_date(info.birthday)} | E-mail: ${info.email}</p>
        <div class="row">
          ${await append_exam(info)}
        </div>
      </div>
    </div>
  `;
  document.querySelector('.exams-list').innerHTML = card;
}

async function main() {
  try {
    await append_person(token);
  } catch (error) {
    try {
      host_port = 'http://app:3000'
      exam_details = `${host_port}/tests/`;
      await append_person(token);
    } catch {
      let message = "<p style='color: #ba1234'>Ocorreu um erro e não foi possível conectar ao banco de dados, contate o gerenciador de banco de dados.</p>";
      document.querySelector('.exams-list').innerHTML = message;
    }
  }
}

main();