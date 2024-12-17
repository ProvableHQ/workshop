import credits.aleo;
import access_control.aleo;
program timelocked_credits.aleo;

struct Metadata:
    locker as address;
    lockee as address;

function deposit:
    input r0 as u64.private;
    call credits.aleo/transfer_public_as_signer timelocked_credits.aleo r0 into r1;
    call access_control.aleo/set_timelock self.caller 3u32 into r2;
    async deposit r1 r2 into r3;
    output r3 as timelocked_credits.aleo/deposit.future;

finalize deposit:
    input r0 as credits.aleo/transfer_public_as_signer.future;
    input r1 as access_control.aleo/set_timelock.future;
    await r0;
    await r1;

function withdraw:
    input r0 as u64.private;
    call credits.aleo/transfer_public self.caller r0 into r1;
    cast timelocked_credits.aleo self.caller into r2 as Metadata;
    async withdraw r1 r2 into r3;
    output r3 as timelocked_credits.aleo/withdraw.future;

finalize withdraw:
    input r0 as credits.aleo/transfer_public.future;
    input r1 as Metadata.public;
    get access_control.aleo/timelocks[r1] into r2;
    lte r2 block.height into r3;
    assert.eq r3 true;
    await r0;
