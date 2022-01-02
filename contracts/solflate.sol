// SPDX-License-Identifier: AGPL
pragma solidity ^0.8.9;

// Prior work http://www.paul.sladen.org/projects/pyflate/pyflate-modified-pypy.py

// import "hardhat/console.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";

struct Stream {
    bytes buffer;
    uint256 offset;
}

library IO {
    function append(Stream memory s, bytes memory buffer) public pure {
        s.buffer = bytes.concat(s.buffer, buffer);
    }
}
struct BitFieldObj {
    Stream f;
    uint256 bits;
    bytes bitfield;
    uint256 count;
}
abstract contract BitfieldBase {
    using BytesLib for bytes;
    using IO for Stream;

    function newStream(bytes memory input) public pure returns (Stream memory) {
        return Stream({buffer: input, offset: 0});
    }
    function newObj(
        Stream memory inputStream
    ) public pure returns (BitFieldObj memory) {
        return BitFieldObj({
        f: inputStream,
        bits: 0,
        bitfield: '',
        count: 0
        });
    }

    function _more(BitFieldObj memory o) virtual public pure;
    function snoopbits(BitFieldObj memory o, uint256 length) public  virtual  pure;
    function readbits(BitFieldObj memory o, uint256 length) virtual  public pure;

    function _read(Stream memory f, uint256 length)
        public pure
        returns (bytes memory chunk)
    {
        require(f.offset + length < f.buffer.length, "Length error");
        chunk = f.buffer.slice(f.offset, length);
        f.offset += chunk.length;
    }

    function needbits(BitFieldObj memory o, uint256 length) public pure {
        while (o.bits < length)
          _more(o);
    }
    function _mask(uint256 n) public pure returns (uint256) {
        return uint256((1 << uint(n)) - 1);
    }
    function toskip(BitFieldObj memory o) public pure returns (uint256) {
        return o.bits & 0x7;
    }

    function align(BitFieldObj memory o) public pure {
        readbits(o, toskip(o));
    }

    function dropbits(BitFieldObj memory o, uint256 length) public pure {
        uint256 readLength;
        while (length >= o.bits && length > 7) {
            length = length- o.bits;
            o.bits = 0;
            unchecked {
                readLength = length >> 3;
            }
            bytes memory chunk = _read(o.f, readLength);
            length = length - (chunk.length << 3);
        }
        if (length > 0)
            readbits(o, length);
    }
    function dropbytes(BitFieldObj memory o,uint256 count) public pure {
        dropbits(o, count >> 3);
    }
    function tell(BitFieldObj memory o) public pure returns (uint256 upper, uint256 lower) {
        upper = o.count - ((o.bits+7) >> 3);
        lower = 7 - ((o.bits-1) & 0x07);
    }
    function tellbits(BitFieldObj memory o) public pure returns (uint256) {
        (uint256 bytesN, uint256 bits) = tell(o);
        return (bytesN << 3) + bits;
    }
}

contract Bitfield is BitfieldBase {
    using BytesLib for bytes;

    function _more(BitFieldObj memory o) public override pure {
        // read 1 byte from stream
        bytes memory buf = _read(o.f, 1);
        require(buf.length == 1, "Reached end of stream");
        // Place byte to the left-side of the bitfield
        o.bitfield.concat(buf);
        // Increase length
        o.bits++;
    }
    function snoopbits(BitFieldObj memory o, uint256 count) public  override  pure {
        // TODO
        // if count is above the bitfield length
        // return with bits operation on bitfield
    }
    function readbits(BitFieldObj memory o, uint256 length)  public override pure {
        //TODO
        // read bytes
        // advance offset in stream (IN STREAM)
        // put in bitfields
        // return r
    }
        //

}
/*
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
