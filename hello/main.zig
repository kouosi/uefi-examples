const uefi = @import("std").os.uefi;

// The actual entry point is EfiMain. EfiMain takes two parameters, the
// EFI image's handle and the EFI system table, and writes them to
// uefi.handle and uefi.system_table, respectively. The EFI system table
// contains function pointers to access EFI facilities.
//
// main() can return void or usize.
pub fn main() void {
    // uefi.system_table.con_out is a handle for the active console output
    // device. It is a pointer to a structure that implements
    // uefi.protocols.SimpleTextOutputProtocol. You can think of
    // EFI protocols as interfaces to access devices and certain parts of
    // your computer's firmware.
    const con_out = uefi.system_table.con_out.?;

    // Clear screen. reset() returns usize(0) on success, like most
    // EFI functions. reset() can also return something else in case a
    // device error occurs, but we're going to ignore this possibility now.
    _ = con_out.reset(false);

    // EFI uses UCS-2 encoded null-terminated strings. UCS-2 encodes
    // code points in exactly 16 bit. Unlike UTF-16, it does not support all
    // Unicode code points.
    _ = con_out.outputString(&[_]u16{ 'H', 'e', 'l', 'l', 'o', ',', ' ', 0 });
    _ = con_out.outputString(&[_]u16{ 'w', 'o', 'r', 'l', 'd', '\r', '\n', 0 });
    // EFI uses \r\n for line breaks (like Windows).

    // Boot services are EFI facilities that are only available during OS
    // initialization, i.e. before your OS takes over full control over the
    // hardware. Among these are functions to configure events, allocate
    // memory, load other EFI images, and access EFI protocols.
    const boot_services = uefi.system_table.boot_services.?;
    // There are also Runtime services which are available during normal
    // OS operation.

    // uefi.system_table.con_out and uefi.system_table.boot_services should be
    // set to null after you're done initializing everything. Until then, we
    // don't need to worry about them being inaccessible.

    // Wait 5 seconds.
    _ = boot_services.stall(5 * 1000 * 1000);

    // If main()'s type is void, EfiMain will return usize(0). On return,
    // control is transferred back to the calling EFI image.
}
