let url = '';
function render_exam_dark(){
  url = `http://localhost:3000/exams-dark/`;
  render();
}

function render_exam(){
  url = `http://localhost:3000/exams/`;
  render();
}

function render(){
  input = document.getElementById('token');
  token = input.value;
  window.location.replace(`${url}${token}`)
}