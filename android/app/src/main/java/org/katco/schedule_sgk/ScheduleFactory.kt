package org.katco.schedule_sgk

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.widget.RemoteViews
import android.widget.RemoteViewsService.RemoteViewsFactory
import androidx.annotation.RequiresApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.katco.schedule_sgk.model.Lesson
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class ScheduleFactory(private val context: Context, intent: Intent) : RemoteViewsFactory {

    private val data = mutableListOf<Lesson>()
    private val widgetID = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)

    override fun onCreate() {

    }

    override fun getCount(): Int {
        return data.size
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewAt(position: Int): RemoteViews {
        val rView = RemoteViews(context.packageName, R.layout.lesson_item)
        rView.setTextViewText(R.id.tvItemText, data[position].title)
        return rView
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    override fun onDataSetChanged() {
        kotlin.io.println("TEST!")
        kotlinx.coroutines.runBlocking {
            kotlin.io.println("TEST!")
            data.clear()
            val sharedPreferencesName = "FlutterSharedPreferences"
            val pref = context.getSharedPreferences(sharedPreferencesName, Context.MODE_PRIVATE)
            val widgetKey = pref.getString("widget_key", "") ?: ""
            val widgetType = pref.getString("widget_type", "")

            when (widgetType?.toLowerCase()) {
                "group" -> {
                    data.addAll(ApiService().getGroupSchedule(widgetKey, getCurrentDate()))
                }
                "teacher" -> {
                    data.addAll(ApiService().getTeacherSchedule(widgetKey, getCurrentDate()))
                }
                "cabinet" -> {
                    data.addAll(ApiService().getCabinetSchedule(widgetKey, getCurrentDate()))
                }
                else -> {
                    // Handle the case when widgetType is not one of the known types
                }
            }

            kotlin.io.println(data.size) // This line is now inside the block

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = intArrayOf(widgetID)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.lvList)
        }
    }

    override fun onDestroy() {

    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private fun getCurrentDate(): String {
        val currentDate = LocalDate.now()
        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
        return currentDate.format(formatter)
    }
}
