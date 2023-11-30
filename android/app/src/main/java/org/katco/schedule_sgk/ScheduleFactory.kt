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
        data.clear()
        val sharedPreferencesName = "FlutterSharedPreferences"
        val pref = context.getSharedPreferences(sharedPreferencesName, Context.MODE_PRIVATE)
        val widgetKey = pref.getString("widget_key", "") ?: ""
        val widgetType = pref.getString("widget_type", "")

        GlobalScope.launch {
            try {
                when (widgetType?.toLowerCase()) {
                    "group" -> {
                        val result = ApiService().getGroupScheduleAsync(widgetKey, getCurrentDate())
                        data.addAll(result as List<Lesson>)
                    }
                    "teacher" -> {
                        val result = ApiService().getTeacherScheduleAsync(widgetKey, getCurrentDate())
                        data.addAll(result)
                    }
                    "cabinet" -> {
                        val result = ApiService().getCabinetScheduleAsync(widgetKey, getCurrentDate())
                        data.addAll(result as List<Lesson>)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
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
