name: string = "Wrapped Ether"
symbol: string = "WETH"
_balances:private(uint256(wei)[address])
_allowance: private((uint256(wei)[address])[address])
_totalSupply: private(uint256(wei))

Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256(wei)})
Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256(wei)})
Deposit: event({_owner: indexed(address), _value: uint256(wei)})
Withdrawal: event({_owner: indexed(address), _value: uint256(wei)})

@public
@constant
def getBalance(_address: address) -> uint256(wei):
	return self._balances[address]

@public
@constant
def allowed(_owner: address, _spender: address) -> uint256(wei):
	return self._allowance[_owner][_spender]

@public
@constant
def totalSupply() -> uint256(wei):
	return self._totalSupply

@public
@payable
def __default__():
	self.deposit()

@public
@payable
def deposit():
	_sender: address = msg.sender
	_value: uint256(wei) = msg.value
	self._totalSupply += _value
	self._balances[_sender] = self._balances[_sender] += _value
	log.Deposit(ZERO_ADDRESS, _sender, _value)
	
@public
def withdraw(_amount: uint256(wei)):
	assert self._balances[msg.sender] >= _amount
	self._balances[msg.sender] -= _amount
	self._totalSupply -= _amount
	send(msg.sender, _amount)
	log.Withdrawal(msg.sender, _amount)

@public
def transfer(_to: address, _amount: uint256(wei)):
	assert self._balances[msg.sender] >= _amount
	assert not _to == ZERO_ADDRESS
	self._balances[msg.sender] -= _amount
	self._balances[_to] += _amount
	log.Transfer(msg.sender, _to, _amount)

@public 
def approve(_to: address, _amount: uint256(wei)):
	self._allowance[msg.sender][_to] = _amount
	log.Approval(msg.sender, _to, _amount)

@public
def transferFrom(_from: address, _amount: uint256(wei)):
	assert self._balances[_from] >= _amount
	assert self._allowance[_from][msg.sender] >= _amount
	self._allowance[_from][msg.sender] -= _amount
	self._balances[_from] -= _amount
	self._balances[msg.sender] += _amount
	log.Transfer(_from, msg.sender, _amount)

