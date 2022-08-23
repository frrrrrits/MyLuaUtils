package your_package;

import androidx.lifecycle.MediatorLiveData;

// why in java, because we cant override protected func in lua
public class LuaLiveData extends MediatorLiveData<Object> {

    private Lin lin;

    public LuaLiveData(Lin lin) {
        this.lin = lin;
    }

    @Override
    protected void onActive() {
        lin.onActive();
    }

    @Override
    protected void onInactive() {
        lin.onInactive();
    }

    public interface Lin {
        void onInactive();
        void onActive();
    }
}

