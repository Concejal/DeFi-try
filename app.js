// Utiliza web3 para conectarse a la billetera del usuario
async function conectarBilletera() {
    if (window.ethereum) {
        window.web3 = new Web3(window.ethereum);
        try {
            // Solicitar al usuario que conecte su billetera
            await window.ethereum.enable();
            console.log('Billetera conectada:', window.web3.currentProvider.selectedAddress);
        } catch (error) {
            console.error('Error al conectar la billetera:', error);
        }
    } else {
        console.error('Web3 no está disponible. Instale MetaMask u otro proveedor de Web3.');
    }
}

// Actualiza la puntuación del jugador en el contrato Solidity
async function actualizarPuntuacion() {
    const contratoAddress = 'DIRECCION_DEL_CONTRATO'; // Reemplaza con la dirección real del contrato
    const contratoABI = [...]; // Reemplaza con el ABI real del contrato

    const contrato = new window.web3.eth.Contract(contratoABI, contratoAddress);

    const nuevaPuntuacion = Math.floor(Math.random() * 100); // Puntuación aleatoria para este ejemplo

    try {
        const resultado = await contrato.methods.actualizarPuntuacion(nuevaPuntuacion).send({ from: window.web3.currentProvider.selectedAddress });
        console.log('Transacción enviada:', resultado);
    } catch (error) {
        console.error('Error al enviar la transacción:', error);
    }
}
