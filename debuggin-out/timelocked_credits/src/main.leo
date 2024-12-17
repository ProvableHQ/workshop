import credits.aleo;
import access_control.aleo;

program timelocked_credits.aleo {
    struct Metadata {
        locker: address,
        lockee: address,
    }

    async transition deposit(amount: u64) -> Future {
        let f1: Future = credits.aleo/transfer_public_as_signer(timelocked_credits.aleo, amount);
        let f2: Future = access_control.aleo/set_timelock(self.caller, 3u32);
        return compose_two_futures(f1, f2);
    }

    async function compose_two_futures(f1: Future, f2: Future) {
        f1.await();
        f2.await();
    }

    async transition withdraw(amount: u64) -> Future {
        let f: Future = credits.aleo/transfer_public(self.caller, amount);
        let metadata: Metadata = Metadata {
            locker: timelocked_credits.aleo,
            lockee: self.caller,
        };
        return check_and_finish_withdraw(f, metadata);
    }

    async function check_and_finish_withdraw(f: Future, metadata: Metadata) {
        assert(Mapping::get(access_control.aleo/timelocks, metadata) <= block.height);
        f.await();
    }

        
}
