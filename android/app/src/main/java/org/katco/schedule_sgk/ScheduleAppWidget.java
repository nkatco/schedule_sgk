package org.katco.schedule_sgk;

import android.appwidget.AppWidgetProvider;

import java.sql.Date;
import java.text.SimpleDateFormat;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;
public class ScheduleAppWidget extends AppWidgetProvider {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date date = new Date(System.currentTimeMillis());

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager,
                         int[] appWidgetIds) {
        super.onUpdate(context, appWidgetManager, appWidgetIds);
        for (int i : appWidgetIds) {
            updateWidget(context, appWidgetManager, i);
        }
    }

    void updateWidget(Context context, AppWidgetManager appWidgetManager,
                      int appWidgetId) {
        RemoteViews rv = new RemoteViews(context.getPackageName(),
                R.layout.schedule_app_widget);

        setUpdateTV(rv, context, appWidgetId);

        setList(rv, context, appWidgetId);

        setListClick(rv, context, appWidgetId);

        appWidgetManager.updateAppWidget(appWidgetId, rv);
        appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId,
                R.id.lvList);
    }

    void setUpdateTV(RemoteViews rv, Context context, int appWidgetId) {
        rv.setTextViewText(R.id.tvUpdate,
                sdf.format(date));
        Intent updIntent = new Intent(context, ScheduleAppWidget.class);
        updIntent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        updIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS,
                new int[]{appWidgetId});
        PendingIntent updPIntent = PendingIntent.getBroadcast(context,
                appWidgetId, updIntent, PendingIntent.FLAG_IMMUTABLE);
        rv.setOnClickPendingIntent(R.id.tvUpdate, updPIntent);
    }

    void setList(RemoteViews rv, Context context, int appWidgetId) {
        Intent adapter = new Intent(context.getApplicationContext(), ScheduleService.class);
        adapter.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        rv.setRemoteAdapter(R.id.lvList, adapter);
    }

    void setListClick(RemoteViews rv, Context context, int appWidgetId) {

    }
}
