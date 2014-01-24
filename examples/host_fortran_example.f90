module test
  contains
subroutine printerror(host, errorcode, privatedata) BIND(C)
  use ISO_C_BINDING
  use OPI
  type(c_ptr), value :: host
  integer(c_int), value :: errorcode
  type(c_ptr), value :: privatedata
  write(*,*) 'OPI Error: ', OPI_ErrorMessage(errorcode)

end subroutine
end module
program opi_host_fortran_test
  use OPI
  use OPI_Types
  use test

  type(c_ptr) :: host
  type(c_ptr) :: data
  type(c_ptr) :: propagator
  integer(C_INT) :: status
  type(OPI_Orbit),pointer :: orbit (:)

  ! create host
  host = OPI_createHost()

  call OPI_setErrorCallback(host, C_FUNLOC(printerror), C_NULL_PTR)

  ! load plugins
  status = OPI_loadPlugins(host, "plugins")

  ! create data object AFTER! loading all support plugins
  data = OPI_createData(host, 200)

  write(*,*) 'Registered Propagator:'
  do 10 i = 1, OPI_getPropagatorCount(host), 1
    write(*,*) '# ', i, ': ', OPI_Module_getName(OPI_getPropagator(host, i - 1))

  10 continue

  ! find a specific propagator
  propagator = OPI_getPropagator(host, "CPP Example Propagator")

  ! a null-pointer (0) is returned if no propagator is found
  if(.NOT. C_ASSOCIATED(propagator)) then
    write(*,*) 'Propagator not found'
  else
    ! run propagation of our test propagator
    status = OPI_Propagator_propagate(propagator, data, 0., 0., 0.)

    ! retrieve orbital data values
    orbit => OPI_ObjectData_getOrbit(data)
    ! print inclination values
    do 20 i = 1, 200, 1
      write(*,*) orbit(i)%inclination
    20  continue
  end if

  ! free data
  status = OPI_destroyData(data)

  ! drop host
  status = OPI_destroyHost(host)
end program opi_host_fortran_test