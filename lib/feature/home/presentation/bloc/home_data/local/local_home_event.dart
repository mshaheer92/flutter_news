abstract class LocalHomeDataEvent {
  const LocalHomeDataEvent();
}

class GetHomeData extends LocalHomeDataEvent {
  const GetHomeData();
}
class GetDailyNews extends LocalHomeDataEvent {
  const GetDailyNews();
}