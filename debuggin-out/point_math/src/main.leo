program point_math.aleo {
    record Point {
        owner: address,
        x: u32,
        y: u32,
    }

    // Create a new point.
    transition create_point(x: u32, y: u32) -> Point {
        return Point {
            owner: self.caller,
            x: x,
            y: y
        };
    }

    // Add two points.
    transition add_points(p1: Point, p2: Point) -> Point {
        return Point {
            owner: p1.owner,
            x: p1.x + p2.x,
            y: p1.y + p2.y
        };
    }

    // Calculate the distance between two points.
    transition distance(p1: Point, p2: Point) -> u32 {
        let x_diff: u32 = ((p1.x as i64) - (p2.x as i64)).abs() as u32;
        let y_diff: u32 = ((p1.y as i64) - (p2.y as i64)).abs() as u32;
        return sqrt_bitwise(x_diff * x_diff + y_diff * y_diff);
    }

    // An implementation of integer square root.
    function sqrt_bitwise(n: u32) -> u32 {
        let res: u32 = 0u32;
        // Iterate over all 32 bits from most significant to least significant
        for inv_shift: u8 in 0u8..32u8 {
            let shift: u8 = 31u8 - inv_shift;
            let bit: u32 = 1u32 << shift;
            let temp: u32  = res | bit;
            // Check if temp is safe to square without overflow
            if temp <= 65535u32 { // √(2^32 - 1) = 65535
                let square: u32 = temp.mul_wrapped(temp);
                if square <= n {
                    res = temp; // Update res if temp^2 <= n
                }
            }
        }
        return res;
    }
}
