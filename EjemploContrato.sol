// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JuegoContrato {
    address public owner;
    mapping(address => uint256) public puntuaciones;

    event PuntuacionActualizada(address jugador, uint256 nuevaPuntuacion);

    constructor() {
        owner = msg.sender;
    }

    modifier soloPropietario() {
        require(msg.sender == owner, "Solo el propietario puede llamar a esta función");
        _;
    }

    function actualizarPuntuacion(uint256 nuevaPuntuacion) external {
        puntuaciones[msg.sender] = nuevaPuntuacion;
        emit PuntuacionActualizada(msg.sender, nuevaPuntuacion);
    }
}
