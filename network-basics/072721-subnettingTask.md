Task : `You have subnetted the 172.30.10.0 network with a mask of 255.255.255.192. How many usable subnets will you have and how many hosts are available on each subnet? (pick two)`

- A) 64 hosts
- B) 62 hosts
- C) 192 hosts
- D) 2 subnets
- E) 3 subnets
- F) 4 subnets

## Solution:

Network Id: `172.30.10.0`

Mask: `255.255.255.192`

first, second, third masks bits = 24

4th octet mask bits: 11000000
Therefore, `subnet mask` = 26

Binary= /26 - 11111111.11111111.11111111.11000000
Decimal= 255.255.255.192

`With the borrowed bits` 2^2 = 4 subnets can be created.

`With remaining bits` 2^6-2= 62 usable hosts per subnet can be assigned.


## Subnets:
172.30.10.0 => 10101100.00011110.00001010.00`000000`

172.30.10.64 => 10101100.00011110.00001010.01`000000`

172.30.10.128 => 10101100.00011110.00001010.10`000000`

172.30.10.192 => 10101100.00011110.00001010.11`000000`


Based on above explanation the correct answer: `B and F`