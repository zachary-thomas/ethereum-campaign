const assert = require('assert');
const ganache = require('ganache-cli');
// Constructor function, capitalized
const Web3 = require('web3');
const { abi, evm } = require('../compile');
//import Constants from '../constants.js'
const constants = require('../constants')

// Instance of web3 to connect to test network
// through the provider (provider depends on network)
const web3 = new Web3(ganache.provider());

// Note the async keyword
beforeEach( async () => {


});

describe('Inbox', () => {

});