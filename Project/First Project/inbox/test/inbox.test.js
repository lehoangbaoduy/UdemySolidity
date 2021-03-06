const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());

// ABI and bytecode
const { abi, evm } = require('../compile');

let accounts;
let inbox;

beforeEach(async() => {
    // Get a list of all accounts
    accounts = await web3.eth.getAccounts();

    // Use one of those accounts to deploy the contract
    inbox = await new web3.eth.Contract(abi)
        .deploy({
            data: evm.bytecode.object,
            arguments: ['Hi there!'],
        })
        .send({ from: accounts[0], gas: '1000000' });
});

describe('Inbox', () => {
    it('deploys a contract', () => {
        // test if we deployed the contract
        // by checking if there is an address assigned to the contract
        assert.ok(inbox.options.address);
    });

    it('has default message', async() => {
        const message = await inbox.methods.message().call();
        assert.equal(message, "Hi there!");
    });

    it('can change a message', async() => {
        await inbox.methods.setMessage("New message").send({ from: accounts[0] });
        const message = await inbox.methods.message().call();
        assert.equal(message, "New message");
    });
});