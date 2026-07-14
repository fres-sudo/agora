/// A stable identity for one `apps/agora` install, generated once and
/// persisted for the lifetime of that install. Attached to every synced
/// payload as `originDeviceId` so peers (and, later, kitchen ticket
/// routing) can tell stations apart — never derived from anything
/// station-local like a Drift row id.
extension type const DeviceId(String value) {}
