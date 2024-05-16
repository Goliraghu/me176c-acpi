Scope (\_SB.PCI0.PEG0.PEGP)
{
    /*
     * This is a PCI bridge device present on PEGP.
     * Normally seen as pci-bridge in I/O Registry.
     */
    Device (BRG0)
    {
        Name (_ADR, Zero)
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }

        /*
         * This is an actual GPU device present on the bridge.
         * Normally seen as display in I/O Registry.
         */
        Device (GFX0)
        {
            Name (_ADR, Zero)  // _ADR: Address
        }
    }
}
