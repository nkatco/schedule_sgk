package org.katco.schedule_sgk

import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import org.katco.schedule_sgk.model.Lesson
import org.json.JSONArray
import org.json.JSONObject
import java.io.IOException

class ApiService {

    private val client = OkHttpClient()

    suspend fun getGroupScheduleAsync(groupKey: String, date: String): Any? {
        return withContext(Dispatchers.IO) {
            val url = "https://asu.samgk.ru/api/schedule/$groupKey/$date"
            println(url)
            val response = fetchData(url)
            parseResponse(response)
        }
    }

    suspend fun getTeacherScheduleAsync(teacherKey: String, date: String): List<Lesson> {
        return withContext(Dispatchers.IO) {
            val url = "https://asu.samgk.ru/api/schedule/teacher/$date/$teacherKey"
            println(url)
            val response = fetchData(url)
            parseResponse(response)
        }
    }

    suspend fun getCabinetScheduleAsync(cabinetKey: String, date: String): Any? {
        return withContext(Dispatchers.IO) {
            val url = "https://asu.samgk.ru/api/schedule/cabs/$date/cabNum/$cabinetKey"
            println(url)
            val response = fetchData(url)
            parseResponse(response)
        }
    }

    private fun fetchData(url: String): String {
        val request = Request.Builder()
                .url(url)
                .build()

        return try {
            val response = client.newCall(request).execute()
            println(response.body)
            response.body?.string() ?: ""
        } catch (e: IOException) {
            e.printStackTrace()
            ""
        }
    }

    private fun parseResponse(response: String): List<Lesson> {
        val lessons = mutableListOf<Lesson>()

        try {
            val jsonObject = JSONObject(response)

            if (jsonObject.has("lessons")) {
                val lessonsArray = jsonObject.getJSONArray("lessons")

                for (i in 0 until lessonsArray.length()) {
                    val jsonLesson: JSONObject = lessonsArray.getJSONObject(i)
                    val lesson = Lesson(
                        title = jsonLesson.optString("title", ""),
                        num = jsonLesson.optInt("num", 0),
                        teacherName = jsonLesson.optString("teachername", ""),
                        cab = jsonLesson.optString("cab", "")
                    )
                    lessons.add(lesson)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("ApiService", "Error parsing response: ${e.message}", e)
        }

        return lessons
    }
}
