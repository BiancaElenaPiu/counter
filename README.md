**Counter Smart Contract Documentation**

**Overview**

This Move module implements a simple Counter smart contract on the Sui blockchain.
Each user can create and own a Counter object, increment it, and query its value and timestamp.
It also includes access control (only the owner can increment their counter) and emits events for transparency.

**Deployment Instructions**

1st Step: Build the Contract  : sui move build

2nd Step: Deploy to Testnet : sui client publish

After successful deployment, note:

Package ID : 0x1e38c7567723441948e2a2da9ae8785fffef7302ae6c23347633e626b33d6a45
| **Sui Explorer (Package)** | [ View Package on Explorer](https://testnet.suivision.xyz/package/0x1e38c7567723441948e2a2da9ae8785fffef7302ae6c23347633e626b33d6a45)

Transaction Digest : 2H6Q3D3WvfkEDn2mhL7JxoTAJWb2XgHTMk9yHLxyVXBC

Create a counter :
sui client call \
  --package 0x1e38c7567723441948e2a2da9ae8785fffef7302ae6c23347633e626b33d6a45\
  --module counter \
  --function create_counter \

Copy the Counter Object ID from output

created object:
0xa24fbbfbf98a7cf5d1fc71223d8d7e0a4aba812dc4a6f08aea5c1cfa97a1ae3e  

Increment the Counter:
sui client call \
  --package 0x1e38c7567723441948e2a2da9ae8785fffef7302ae6c23347633e626b33d6a45 \
  --module counter \
  --function increment \
  --args 0xa24fbbfbf98a7cf5d1fc71223d8d7e0a4aba812dc4a6f08aea5c1cfa97a1ae3e   \

| **Sui Explorer (Counter) - after two increments** | [ View Counter on Explorer](https://testnet.suivision.xyz/object/0xa24fbbfbf98a7cf5d1fc71223d8d7e0a4aba812dc4a6f08aea5c1cfa97a1ae3e)

**Implementation**


**Project Structure**
 - counter.move — contains the full implementation of the Counter module.
   
Defines the Counter object, events, and all entry/public functions (create_counter, increment, get_value, get_timestamp).

- counter_tests.move — includes comprehensive unit tests to ensure:

    - Counter creation initializes correctly

    - Only the owner can increment

    - Timestamp updates properly

    - Unauthorized access is prevented


    







