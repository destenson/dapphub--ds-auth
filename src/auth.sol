// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.4.16;

contract DSAuthority {
    // Can msg.sender (src) call a function (sig) on contract (dst)?
    function canCall(address src, address dst, bytes4 sig) public view returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority public _authority;
    address private _owner;

    function DSAuth() public {
        setOwner(msg.sender);
    }

    function owner() public view returns (address) { return _owner; }
    function authority() public view returns (address) { return _authority; }

    function setOwner(address owner) public auth {
        _owner = owner;
        LogSetOwner(owner);
    }

    function setAuthority(DSAuthority authority) public auth {
        _authority = authority;
        LogSetAuthority(authority);
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        return (src == address(this)) || (src == _owner) || (DSAuthority(0) != _authority) || _authority.canCall(src, this, sig);
    }
}
