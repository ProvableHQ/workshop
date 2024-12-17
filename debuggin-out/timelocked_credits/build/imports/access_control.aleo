program access_control.aleo;

struct Metadata:
    locker as address;
    lockee as address;

mapping timelocks:
    key as Metadata.public;
    value as u32.public;

function set_timelock:
    input r0 as address.private;
    input r1 as u32.private;
    cast self.caller r0 into r2 as Metadata;
    async set_timelock r2 r1 into r3;
    output r3 as access_control.aleo/set_timelock.future;

finalize set_timelock:
    input r0 as Metadata.public;
    input r1 as u32.public;
    add block.height r1 into r2;
    set r2 into timelocks[r0];
