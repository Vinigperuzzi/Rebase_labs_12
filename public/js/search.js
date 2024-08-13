let url = '';
function getHost(){
  return window.location.hostname === 'localhost' ? 'localhost' : 'app'
}

function render_exam_dark(){
  const host = getHost();
  url = `http://${host}:3000/exams-dark/`;
  render();
}

function render_exam(){
  const host = getHost();
  url = `http://${host}:3000/exams/`;
  render();
}

function render(){
  input = document.getElementById('token');
  token = input.value;
  if(token == ''){
    token = '0';
  }
  window.location.replace(`${url}${token}`)
}