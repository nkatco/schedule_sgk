package org.katco.schedule_sgk

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.katco.schedule_sgk.model.Lesson
import java.text.SimpleDateFormat
import java.util.*

class ExampleAppWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val sharedPreferences = context.getSharedPreferences(
                    "org.katco.schedule_sgk.PREFS",
                    Context.MODE_PRIVATE
            )
            val widgetAuthor = sharedPreferences.getString("widget_author", "") ?: ""
            println("Author: $widgetAuthor")
            val apiService = ApiService()

            CoroutineScope(Dispatchers.Main).launch {
                val lessons = apiService.getGroupSchedule("your_group_key", getCurrentDate())
                updateWidget(context, appWidgetManager, appWidgetId, widgetAuthor, lessons)
            }
        }
    }
    private fun getCurrentDate(): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return sdf.format(Date())
    }

    private fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            widgetAuthor: String,
            lessons: List<Lesson>
    ) {
        val views: RemoteViews = RemoteViews(
                context.packageName,
                R.layout.appwidget_provider_layout
        ).apply {
            setTextViewText(R.id.date, getCurrentDate())
            setTextViewText(R.id.widget_author, widgetAuthor)

            val lessonsText = StringBuilder()
            for (lesson in lessons) {
                lessonsText.append("${lesson.title} - ${lesson.teacherName}\n")
            }
            setTextViewText(R.id.lesson_list, lessonsText.toString())

            val reloadIntent = Intent(context, ExampleAppWidgetProvider::class.java)
                    .setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                    .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(appWidgetId))
            val pendingIntent: PendingIntent =
                    PendingIntent.getBroadcast(context, 0, reloadIntent, PendingIntent.FLAG_UPDATE_CURRENT)
            setOnClickPendingIntent(R.id.reload_button, pendingIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
