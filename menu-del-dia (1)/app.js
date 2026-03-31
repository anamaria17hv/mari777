let restaurantes = JSON.parse(localStorage.getItem('restaurantes')) || [];

function mostrar(vista){
  document.getElementById('registro').style.display='none';
  document.getElementById('resultados').style.display='none';
  document.getElementById(vista).style.display='block';
  if(vista==='resultados') render();
}

function guardar(){
  const nombre = document.getElementById('nombre').value;
  const menu = document.getElementById('menu').value;
  const precio = document.getElementById('precio').value;

  if(!nombre || !menu || !precio){
    alert('Completa todos los campos');
    return;
  }

  restaurantes.push({nombre, menu, precio});
  localStorage.setItem('restaurantes', JSON.stringify(restaurantes));

  document.getElementById('nombre').value='';
  document.getElementById('menu').value='';
  document.getElementById('precio').value='';

  alert('Guardado correctamente');
}

function render(){
  const lista = document.getElementById('lista');
  lista.innerHTML='';

  restaurantes.forEach((r, i)=>{
    lista.innerHTML += `
      <div class="card">
        <strong>${r.nombre}</strong><br>
        ${r.menu} - $${r.precio}<br>
        <button onclick="eliminar(${i})">Eliminar</button>
      </div>
    `;
  });
}

function eliminar(i){
  restaurantes.splice(i,1);
  localStorage.setItem('restaurantes', JSON.stringify(restaurantes));
  render();
}
