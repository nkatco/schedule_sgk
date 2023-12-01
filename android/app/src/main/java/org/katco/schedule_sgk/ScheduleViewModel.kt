package org.katco.schedule_sgk
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import org.katco.schedule_sgk.model.Lesson

class ScheduleViewModel : ViewModel() {

    private val _lessons = MutableLiveData<List<Lesson>>()
    val lessons: LiveData<List<Lesson>> get() = _lessons

    fun fetchData(widgetKey: String, widgetType: String) {
        viewModelScope.launch {
            val data = when (widgetType.toLowerCase()) {
                "group" -> ApiService().getGroupSchedule(widgetKey, getCurrentDate())
                "teacher" -> ApiService().getTeacherSchedule(widgetKey, getCurrentDate())
                "cabinet" -> ApiService().getCabinetSchedule(widgetKey, getCurrentDate())
                else -> emptyList()
            }
            _lessons.postValue(data)
        }
    }

    private fun getCurrentDate(): String {
        // Your date logic here
    }
}
