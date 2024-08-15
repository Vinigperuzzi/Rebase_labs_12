function send_data() {
  const fileInput = document.getElementById('file-data');
  const file = fileInput.files[0];

  if (file) {
    const formData = new FormData();
    formData.append('file', file);

    fetch('/import', {
      method: 'POST',
      body: formData
    });
    alert('Requisição enviada ao servidor, volte mais tarde ver as atualizações');
  } else {
    alert('Por favor, selecione um arquivo.');
  }
}