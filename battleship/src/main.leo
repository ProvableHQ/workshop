// Battleship boards are represented by 8x8 squares.
// A u64 is all that is required to represent a hit or a miss on a single board.
// Starting from the top row, left to right, a hit is 1 and a miss is 0.
// A first move resulting in a hit in row 1, column 3 would be:
// 00100000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
// A second u64 is needed to represent which squares have been played, with 1s being played squares and 0s being
// unplayed squares.
record BoardState {
    owner: address,
    gates: u64,
    // The hits and misses registered on the opponent's board.
    hits_and_misses: u64,
    // The squares that have been played on the opponent's board.
    played_tiles: u64,
    // The ship bitstring representing all ship positions on your own board
    ships: u64,
    player_1: address,
    player_2: address,
    game_started: bool,
}

// Returns a new BoardState.
@program
function new_board_state(
    ships: u64,
    opponent: address,
) -> BoardState {
    return BoardState {
        owner: self.caller,
        gates: 0u64,
        hits_and_misses: 0u64,
        played_tiles: 0u64,
        ships,
        player_1: self.caller,
        player_2: opponent,
        game_started: false,
    };
}

// Returns a new board state that has been started.
// Fails if this board has been started before.
@program
function start_board(
    // The record of the board to start. A board can only be started once.
    board: BoardState,
) -> BoardState {
    // Ensure this board hasn't been used to start a game before.
    console.assert(!board.game_started);

    return BoardState {
        owner: board.owner,
        gates: board.gates,
        hits_and_misses: board.hits_and_misses,
        played_tiles: board.played_tiles,
        ships: board.ships,
        player_1: board.player_1,
        player_2: board.player_2,
        game_started: true,
    };
}

// Returns a new board state record that includes all the played tiles.
// Fails if r1 has been played before.
@program
function update_played_tiles(
    // The record of the board to update.
    board: BoardState,
    // The u64 equivalent of a bitstring fire coordinate to send to the opponent.
    shoot: u64,
) -> BoardState {
    // Need to make sure r1 is a valid move. Only one bit of r1 should be flipped.
    let flip_bit: u64 = shoot - 1u64;
    // bitwise and operation
    let check_move: u64 = shoot & flip_bit;
    console.assert_eq(check_move, 0u64);

    // Need to make sure r1 is a valid move given the played_tiles. no bits should overlap.
    let check_tiles: u64 = shoot & board.played_tiles;
    console.assert_eq(check_tiles, 0u64);

    // Update played tiles.
    let played_tiles: u64 = board.played_tiles | shoot;

    return BoardState {
        owner: board.owner,
        gates: board.gates,
        hits_and_misses: board.hits_and_misses,
        played_tiles,
        ships: board.ships,
        player_1: board.player_1,
        player_2: board.player_2,
        game_started: board.game_started,
    };
}

// Returns a new board state record that includes all the hits and misses.
@program
function update_hits_and_misses(
    // The record of the board to update.
    board: BoardState,
    // The u64 equivalent of a bitstring of whether this player's previous move was a hit or miss.
    hit_or_miss: u64,
) -> BoardState {
    // Update hits and misses.
    let hits_and_misses: u64 = board.hits_and_misses | hit_or_miss;

    return BoardState {
        owner: board.owner,
        gates: board.gates,
        hits_and_misses,
        played_tiles: board.played_tiles,
        ships: board.ships,
        player_1: board.player_1,
        player_2: board.player_2,
        game_started: board.game_started,
    };
}


/// Code for Player Moves


record Move {
    owner: address,
    gates: u64,
    incoming_fire_coordinate: u64,
    player_1: address,
    player_2: address,
    // One flipped bit indicates a hit. No flipped bits indicates a miss.
    prev_hit_or_miss: u64,
}

// Returns new move record owned by the opponent.
@program
function create_move(
    // The move record created by the opponent.
    move: Move,
    // The u64 representation of incoming_fire_coordinate, the bitstring fire coordinate to send to the opponent.
    incoming_fire_coordinate: u64,
    // The u64 representation of prev_hit_or_miss, this player's previous fire coordinate as a hit or miss.
    prev_hit_or_miss: u64,
) -> Move {
    // A new move record should be created and owned by the opponent.
    let one_is_owner: bool = move.player_1 == move.owner;
    let opponent: address = one_is_owner ? move.player_2 : move.player_1;

    return Move {
        owner: opponent,
        gates: move.gates,
        incoming_fire_coordinate,
        player_1: move.player_2,
        player_2: move.player_1,
        prev_hit_or_miss,
    };
}

// Returns the move record owned by the opponent.
// Note, this move record contains dummy fire coordinates and previous hit or miss.
@program
function start_game(player_2: address) -> Move {
    return Move {
        owner: player_2,
        gates: 0u64,
        incoming_fire_coordinate: 0u64,
        player_1: self.caller,
        player_2: player_2,
        prev_hit_or_miss: 0u64,
    };
}


// Code for verify


// Returns the number of flipped bits.
// E.g. 17870283321406128128u64, in binary 11111000 00000000 00000000 00000000 00000000 00000000 00000000 00000000,
// returns 5u64;
function bitcount(bits: u64) -> u64 {
    let r1: u64 = bits / 2u64;
    let r2: u64 = bits / 4u64;
    let r3: u64 = bits / 8u64;

    let r4: u64 = r1 & 8608480567731124087u64;
    let r5: u64 = r2 & 3689348814741910323u64;
    let r6: u64 = r3 & 1229782938247303441u64;

    let r7: u64 = bits - r4 - r5 - r6;

    let r8: u64 = r7 / 16u64;
    let r9: u64 = r7 + r8;
    let r10: u64 = r9 & 1085102592571150095u64;
    let r11: u64 = r10 % 255u64;

    return r11;
}

// Returns boolean of whether all the flipped bits in location are "adjacent". Horizontally, this means all flipped bits are
// directly next to each other (111). Vertically, this means all flipped bits are separated by 7 unflipped bits
// (10000000100000001).
function adjacency_check(
    // The u64 representation of a ship's placement in an 8x8 grid.
    ship: u64,
    // The u64 representation of a ship's bitstring, either horizontally or vertically.
    // E.g. a ship of length 3's bit string horizontally would be: 000111 = 7u64. Vertically, the bit string would be:
    // 10000000100000001 = 65793u64.
    orientation: u64,
) -> bool {
    // This may result in 0.
    let division: u64 = ship / orientation;

    // subtracting 1 from 0 will cause an underflow, so we should check for this edge case.
    let is_eq: bool = division == 0u64;

    // if the above division resulted in 0, we know the adjacency check should return false.
    // Setting to r4 to 3 (11) will guarantee failure here.
    let ternary: u64 = is_eq ? 3u64 : division;
    let subtraction: u64 = ternary - 1u64;
    let and: u64 = subtraction & ternary;

    let bits_are_adjacent: bool = and == 0u64;

    return bits_are_adjacent;
}

// Returns boolean of whether adjacent flipped bits don't split a row of size 8.
// E.g. 111000000 has adjacent flipped bits but splits a row: 00000001 11000000
function horizontal_check(
    // The u64 representation of a ship's placement in an 8x8 grid.
    ship: u64,
    // The u64 representation of a ship's bitstring horizontally.
    horizontal: u64,
) -> bool {
    let remainder: u64 = ship % 255u64;
    // This may result in 0.
    let division: u64 = remainder / horizontal;

    // Subtracting 1 from 0 will cause an underflow.
    let is_eq: bool = division == 0u64;

    // Setting to 3 will guarantee failure.
    let ternary: u64 = is_eq ? 3u64 : division;
    let subtraction: u64 = ternary - 1u64;
    let and: u64 = subtraction & ternary;

    let bits_split_row: bool = and == 0u64;

    return bits_split_row;
}

// Returns `true` if the ship placement is valid.
@program
function validate_ship(
    // The u64 representation of a ship's placement in an 8x8 grid.
    ship: u64,
    // The length of the placed ship.
    length: u64,
    // The u64 equivalent of a ship's horizontal bitstring representation.
    horizontal: u64,
    // The u64 equivalent of a ship's vertical bitstring representation.
    vertical: u64,
) -> bool {
    // Check bitcount -- all other validations depend on the bitcount being correct.
    let num_bits: u64 = bitcount(ship);
    console.assert_eq(length, num_bits);

    // Check horizontal bits of ship.
    let is_adjacent: bool = adjacency_check(ship, horizontal); // True if bits are adjacent horizontally.
    let is_horizontal: bool = horizontal_check(ship, horizontal); // True if those horizontal bits are not split across rows.
    let valid_horizontal: bool = is_adjacent && is_horizontal; // True if bits are adjacent horizontally and not split across rows.

    // Check vertical bits of ship.
    let valid_vertical: bool = adjacency_check(ship, vertical); // True if bits are adjacent vertically.

    let ship_is_valid: bool = valid_horizontal && valid_vertical; // Ship is valid if it is vertically or horizontally valid.

    return ship_is_valid;
}

// Returns the u64 representation of all the ships' placements in an 8x8 grid. This function will fail
// if any of the ship placements overlap each other.
@program
function create_board(
    // The u64 representation of a carrier's placement in an 8x8 grid. Length = 5.
    carrier: u64,
    // The u64 representation of a battleship's placement in an 8x8 grid. Length = 4.
    battleship: u64,
    // The u64 representation of a cruiser's placement in an 8x8 grid. Length = 3.
    cruiser: u64,
    // The u64 representation of a destroyer's placement in an 8x8 grid. Length = 2.
    destroyer: u64,
) -> u64 {
    // Bitwise combine the ship placements together
    let ships: u64 = carrier | battleship | cruiser | destroyer;

    let num_bits: u64 = bitcount(ships);
    console.assert_eq(num_bits, 14u64); // Given 4 individually-valid ships, a valid combination should yield exactly 14 flipped bits.

    return ships;
}


// Code for main.


// input r0 (u64): the u64 representation of a carrier's placement in an 8x8 grid. Length = 5.
// input r1 (u64): the u64 representation of a battleship's placement in an 8x8 grid. Length = 4.
// input r2 (u64): the u64 representation of a cruiser's placement in an 8x8 grid. Length = 3.
// input r3 (u64): the u64 representation of a destroyer's placement in an 8x8 grid. Length = 2.
// input r4 (address): the address of the opponent.
@program
function initialize_board(
    carrier: u64,    // Carrier length 5.
    battleship: u64, // Battleship length 4.
    cruiser: u64,    // Cruiser length 3.
    destroyer: u64,  // Destroyer length 2.
    player: address, // Player address.
) -> BoardState {
    // Verify that each individual ship placement bitstring is valid.
    let valid_carrier: bool = validate_ship(carrier, 5u64, 31u64, 4311810305u64);
    console.assert(valid_carrier);

    let valid_battleship: bool = validate_ship(battleship, 4u64, 15u64, 16843009u64);
    console.assert(valid_battleship);

    let valid_cruiser: bool = validate_ship(cruiser, 3u64, 7u64, 65793u64);
    console.assert(valid_cruiser);

    let valid_destroyer: bool = validate_ship(destroyer, 2u64, 3u64, 257u64);
    console.assert(valid_destroyer);

    // Create the board with all the ship placements combined.
    let board: u64 = create_board(carrier, battleship, cruiser, destroyer);

    // Initialize the board state record.
    let state: BoardState = new_board_state(board, player);

    return state;
}

// Returns an updated board state record that has been started. This board cannot be used to start any other games.
// Returns a dummy move record owned by the opponent.
// This function commits a given board to a game with an opponent and creates the initial dummy move.
@program
function offer_battleship(
    // The board record to start a game with.
    board: BoardState,
) -> (BoardState, Move) {
    let state: BoardState = start_board(board);
    let dummy: Move = start_game(board.player_2);

    return (state, dummy);
}

// Returns updated board_state.record that has been started and can no longer be used to join or start new games.
// Returns dummy move record owned by the opponent.
@program
function start_battleship(
    // The board record to play the game with.
    board: BoardState,
    // The move record to play to begin the game. This should be the dummy move record created from offer_battleship.
    move: Move,
) -> (BoardState, Move) {
    // Validate that the move players and board players match each other.
    console.assert_eq(board.player_1, move.player_1);
    console.assert_eq(board.player_2, move.player_2);

    let state: BoardState = start_board(board);
    let dummy: Move = start_game(board.player_2);

    return (state, dummy);
}

// Returns updated board record.
// Returns new move record owned by opponent.
@program
function play(
    // The board record to update.
    board: BoardState,
    // The incoming move from the opponent.
    move: Move,
    // The u64 equivalent of the bitwise representation of the next coordinate to play on the opponent's board.
    shoot: u64,
) -> (BoardState, Move) {
    // Verify the board has been started. This prevents players from starting a game and then creating
    // a brand new board to play with.
    console.assert(board.game_started);

    // Validate that the move players and board players match each other.
    console.assert_eq(board.player_1, move.player_1);
    console.assert_eq(board.player_2, move.player_2);

    // Play coordinate on own board. Will fail if not a valid move.
    let hit_or_miss: BoardState = update_played_tiles(board, shoot);

    // Update own board with result of last shot.
    let next_board: BoardState = update_hits_and_misses(hit_or_miss, move.prev_hit_or_miss);

    // Assess whether incoming fire coordinate is a hit.
    let is_hit: u64 = move.incoming_fire_coordinate & board.ships;

    let next_move: Move = create_move(move, shoot, is_hit);

    return (next_board, next_move);
}