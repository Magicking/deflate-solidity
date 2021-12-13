// SPDX-License-Identifier: AGPL
pragma solidity ^0.8.9;

// http://www.paul.sladen.org/projects/pyflate/pyflate-modified-pypy.py

// import "hardhat/console.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";

struct Stream {
    bytes buffer;
    uint256 offset;
}

library IO {
    function append(Stream memory s, bytes memory buffer) public {
        s.buffer = bytes.concat(s.buffer, buffer);
    }
}

contract BitfieldBase {
    using BytesLib for bytes;
    using IO for Stream;

    uint256 bits;
    uint256 bitfield;
    uint256 count;

    constructor(
        uint256 _bits,
        uint256 _bitfield,
        uint256 _count
    ) public {
        bits = _bits;
        bitfield = _bitfield;
        count = _count;
    }

    // return bytestream
    function _read(Stream memory f, uint256 length)
        internal
        returns (bytes chunk)
    {
        require(f.offset < bytes.length, "Length error");
        chunk = f.buffer.slice(f.offset, length);
        f.offset += chunk.length;
    }

    //needbits
    //_mask
    //toskip
    //align
    //dropbits
    //dropbytes
    //tell
    //tellbits
}
/*
contract Bitfield {}
contract RBitfield {}
contract HuffmanLength {}
contract HuffmanTable {}
contract OrderedHuffmanTable {}

function reverse_bits
function reverse_bytes

function code_length_orders(i):
    uint[] clo = [16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15];
    return clo[i];

function distance_base(i) internal returns (uint) {
    uint[] distance = [1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577];
    return distance[i];
}

function length_base(i) internal returns (uint) {
    uint[] length = [3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258];
    return length[i-257];
}


function extra_distance_bits() {}
function extra_length_bits {}
function move_to_front {}
function bwt_transform {}
function bwt_reverse {}
function compute_used {}
function compute_selectors_list {}
function compute_tables {}
function decode_huffman_block {}
function bzip2_main {}
function gzip_main {}
*/
