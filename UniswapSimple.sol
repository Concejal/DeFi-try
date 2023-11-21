// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UniswapSimple {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public precioTokenA;
    uint256 public precioTokenB;

    event LiquidezDepositada(address proveedor, uint256 cantidadA, uint256 cantidadB);
    event SwapRealizado(address usuario, uint256 cantidadIn, uint256 cantidadOut);

    constructor(address _tokenA, address _tokenB) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    modifier soloPropietario() {
        require(msg.sender == owner, "Solo el propietario puede llamar a esta función");
        _;
    }

    function depositarLiquidez(uint256 cantidadA, uint256 cantidadB) external {
        require(cantidadA > 0 && cantidadB > 0, "La cantidad debe ser mayor que cero");

        // Transfiere los tokens al contrato
        require(tokenA.transferFrom(msg.sender, address(this), cantidadA), "Fallo al transferir tokenA");
        require(tokenB.transferFrom(msg.sender, address(this), cantidadB), "Fallo al transferir tokenB");

        // Emite el evento de liquidez depositada
        emit LiquidezDepositada(msg.sender, cantidadA, cantidadB);
    }

    function realizarSwap(uint256 cantidadIn, address tokenIn, address tokenOut) external {
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "TokenIn no válido");
        require(tokenOut == address(tokenA) || tokenOut == address(tokenB), "TokenOut no válido");
        require(tokenIn != tokenOut, "TokenIn y TokenOut deben ser diferentes");
        require(cantidadIn > 0, "La cantidad debe ser mayor que cero");

        // Calcula la cantidad de tokens de salida usando la proporción actual
        uint256 cantidadOut = (cantidadIn * precioTokenOut()) / precioTokenIn();

        // Realiza el intercambio
        if (tokenIn == address(tokenA)) {
            require(tokenA.transferFrom(msg.sender, address(this), cantidadIn), "Fallo al transferir tokenA");
            require(tokenB.transfer(msg.sender, cantidadOut), "Fallo al transferir tokenB");
        } else {
            require(tokenB.transferFrom(msg.sender, address(this), cantidadIn), "Fallo al transferir tokenB");
            require(tokenA.transfer(msg.sender, cantidadOut), "Fallo al transferir tokenA");
        }

        // Emite el evento de swap realizado
        emit SwapRealizado(msg.sender, cantidadIn, cantidadOut);
    }

    // Calcula el precio actual de tokenA en términos de tokenB
    function precioTokenA() public view returns (uint256) {
        return (tokenB.balanceOf(address(this)) * (10**18)) / tokenA.balanceOf(address(this));
    }

    // Calcula el precio actual de tokenB en términos de tokenA
    function precioTokenB() public view returns (uint256) {
        return (tokenA.balanceOf(address(this)) * (10**18)) / tokenB.balanceOf(address(this));
    }

    // Calcula la cantidad de tokens de salida en función de la cantidad de tokens de entrada
    function precioTokenOut() internal view returns (uint256) {
        return (precioTokenA() * (10**18)) / precioTokenB();
    }

    // Calcula la cantidad de tokens de entrada en función de la cantidad de tokens de salida
    function precioTokenIn() internal view returns (uint256) {
        return (precioTokenB() * (10**18)) / precioTokenA();
    }
}
