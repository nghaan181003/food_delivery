enum Status { ERROR, OK }

extension StatusExt on Status {
  bool get isOK => this == Status.OK;
  bool get isERROR => this == Status.ERROR;
}
