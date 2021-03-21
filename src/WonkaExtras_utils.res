let scanFn = (. acc, value) => {
  switch acc {
  | (_, Some(current)) => (Some(current), Some(value))
  | _ => (None, Some(value))
  }
}
let initialScanValue = (None, None)
