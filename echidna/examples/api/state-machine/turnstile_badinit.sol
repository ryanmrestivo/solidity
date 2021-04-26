pragma solidity ^0.4.16;

contract Turnstile {
  bool private locked = false; // initial state is unlocked

  function coin() {
    locked = false;
  }

  function push() returns (bool) {
    if (locked) {
      return(false);
    } else {
      locked = true;
      return(true);
    }
  }
}
