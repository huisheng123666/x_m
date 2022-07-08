class PageBasic {
  int? page;
  int? total;
  bool? hasMore;
  bool? isLoadMoreing = false;
  bool? isInit = false;
  bool? isErr = false;

  PageBasic({
    this.page = 1,
    this.total = 0,
    this.hasMore = false,
    this.isLoadMoreing = false,
    this.isInit = false,
    this.isErr = false,
  });
}
