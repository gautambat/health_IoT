package com.remotecare.app.spo2.bluetooth;

import java.util.concurrent.LinkedBlockingQueue;

public class ParseRunnable implements Runnable {
    private static int PACKAGE_LEN = 5;
    private boolean isStop = false;
    private OnDataChangeListener mOnDataChangeListener;
    private OxiParams mOxiParams = new OxiParams();
    private LinkedBlockingQueue<Integer> oxiData = new LinkedBlockingQueue<>(256);
    private int[] parseBuf = new int[5];

    public interface OnDataChangeListener {
        void onPulseWaveDetected();

        void onSpO2ParamsChanged();
        void onSpO2WaveChanged(int i);
        void onDataReceived();
    }

    public class OxiParams {
        public int PI_INVALID_VALUE = 15;
        public int PR_INVALID_VALUE = 255;
        public int SPO2_INVALID_VALUE = 127;
        /* access modifiers changed from: private */

        /* renamed from: pi */
        public int f41pi;
        /* access modifiers changed from: private */
        public int pulseRate;
        /* access modifiers changed from: private */
        public int spo2;

        public OxiParams() {
        }

        /* access modifiers changed from: private */
        public void update(int i, int i2, int i3) {
            this.spo2 = i;
            this.pulseRate = i2;
            this.f41pi = i3;
        }

        public int getSpo2() {
            return this.spo2;
        }

        public int getPulseRate() {
            return this.pulseRate;
        }

        public int getPi() {
            return this.f41pi;
        }

        public boolean isParamsValid() {
            int i = this.spo2;
            if (i != this.SPO2_INVALID_VALUE) {
                int i2 = this.pulseRate;
                if (i2 != this.PR_INVALID_VALUE) {
                    int i3 = this.f41pi;
                    if (!(i3 == this.PI_INVALID_VALUE || i == 0 || i2 == 0 || i3 == 0)) {
                        return true;
                    }
                }
            }
            return false;
        }
    }

    public static float getFloatPi(int i) {
        switch (i) {
            case 0:
                return 0.1f;
            case 1:
                return 0.2f;
            case 2:
                return 0.4f;
            case 3:
                return 0.7f;
            case 4:
                return 1.4f;
            case 5:
                return 2.7f;
            case 6:
                return 5.3f;
            case 7:
                return 10.3f;
            case 8:
                return 20.0f;
            default:
                return 0.0f;
        }
    }

    private int toUnsignedInt(byte b) {
        return b & 255;
    }

    public ParseRunnable(OnDataChangeListener onDataChangeListener) {
        this.mOnDataChangeListener = onDataChangeListener;
    }

    public OxiParams getOxiParams() {
        return this.mOxiParams;
    }

    public void add(byte[] bArr) {
        for (byte unsignedInt : bArr) {
            try {
                this.oxiData.put(Integer.valueOf(toUnsignedInt(unsignedInt)));
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public void run() {
        while (!this.isStop) {
            int data = getData();
            if ((data & 128) > 0) {
                this.parseBuf[0] = data;
                for (int i = 1; i < PACKAGE_LEN; i++) {
                    int data2 = getData();
                    if ((data2 & 128) == 0) {
                        this.parseBuf[i] = data2;
                    }
                }
                int[] iArr = this.parseBuf;
                int i2 = iArr[4];
                int i3 = iArr[3] | ((iArr[2] & 64) << 1);
                int i4 = iArr[0] & 15;
                if (!(i2 == this.mOxiParams.spo2 && i3 == this.mOxiParams.pulseRate && i4 == this.mOxiParams.f41pi)) {
                    this.mOxiParams.update(i2, i3, i4);
                    this.mOnDataChangeListener.onSpO2ParamsChanged();
                }
                this.mOnDataChangeListener.onSpO2WaveChanged(this.parseBuf[1]);
                if ((this.parseBuf[0] & 64) != 0) {
                    this.mOnDataChangeListener.onPulseWaveDetected();
                }
            }
        }
    }

    public void stop() {
        this.isStop = false;
    }

    private int getData() {
        try {
            return ((Integer) this.oxiData.take()).intValue();
        } catch (InterruptedException e) {
            e.printStackTrace();
            return 0;
        }
    }
}
