package org.katco.schedule_sgk;

import android.content.Intent;
import android.widget.RemoteViewsService;

public class ScheduleService extends RemoteViewsService {

    @Override
    public RemoteViewsFactory onGetViewFactory(Intent intent) {
        return new ScheduleFactory(getApplicationContext(), intent);
    }
}
