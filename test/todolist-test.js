const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TodoList", function () {
  it("deploys successfully", async function () {
    const TodoList = await ethers.getContractFactory("TodoList");
    const todolist = await TodoList.deploy();

    await todolist.deployed();

    const address = todolist.address

    expect(address).to.not.equal(0x0);
    expect(address).to.not.equal('');
    expect(address).to.not.equal(null);
    expect(address).to.not.equal(undefined);
  });
});
